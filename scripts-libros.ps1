$ErrorActionPreference = "Stop"

$gateway = "http://localhost:8080"
$adminEmail = if ($env:ADMIN_EMAIL) { $env:ADMIN_EMAIL } else { "admin@biblioteca.com" }
$adminPassword = if ($env:ADMIN_PASSWORD) { $env:ADMIN_PASSWORD } else { "admin1234" }

# Los endpoints de escritura exigen JWT: pedimos uno con el usuario ADMIN.
$login = Invoke-RestMethod -Method Post -Uri "$gateway/auth/login" -ContentType "application/json" -Body (@{ email = $adminEmail; password = $adminPassword } | ConvertTo-Json)
$headers = @{ Authorization = "Bearer $($login.token)" }
Write-Output "Autenticado como $adminEmail (rol $($login.rol))"

$libros = @(
    @{ titulo = "Cien años de soledad"; autor = "Gabriel García Márquez"; isbn = "978-84-376-0494-7"; precio = 19.99; stock = 10 },
    @{ titulo = "1984"; autor = "George Orwell"; isbn = "978-84-206-6089-7"; precio = 15.50; stock = 25 },
    @{ titulo = "El principito"; autor = "Antoine de Saint-Exupéry"; isbn = "978-84-150-6015-0"; precio = 9.95; stock = 40 }
)

foreach ($libro in $libros) {
    $json = $libro | ConvertTo-Json
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    try {
        $r = Invoke-RestMethod -Method Post -Uri "$gateway/libros" -Headers $headers -ContentType "application/json; charset=utf-8" -Body $bytes
        Write-Output "Libro creado: $($r.titulo) (id=$($r.id))"
    } catch {
        Write-Output "ERROR libro '$($libro.titulo)': $($_.Exception.Message)"
    }
}
