$ErrorActionPreference = "Stop"

$gateway = "http://localhost:8080"
$adminEmail = if ($env:ADMIN_EMAIL) { $env:ADMIN_EMAIL } else { "admin@biblioteca.com" }
$adminPassword = if ($env:ADMIN_PASSWORD) { $env:ADMIN_PASSWORD } else { "admin1234" }

# Los endpoints de escritura exigen JWT: pedimos uno con el usuario ADMIN.
$login = Invoke-RestMethod -Method Post -Uri "$gateway/auth/login" -ContentType "application/json" -Body (@{ email = $adminEmail; password = $adminPassword } | ConvertTo-Json)
$headers = @{ Authorization = "Bearer $($login.token)" }
Write-Output "Autenticado como $adminEmail (rol $($login.rol))"

$clientes = @(
    @{ nombre = "Juan Pérez"; email = "juan.perez@mail.com"; telefono = "600111222" },
    @{ nombre = "María López"; email = "maria.lopez@mail.com"; telefono = "600333444" },
    @{ nombre = "Carlos Ruiz"; email = "carlos.ruiz@mail.com"; telefono = "600555666" }
)

foreach ($cliente in $clientes) {
    $json = $cliente | ConvertTo-Json
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    try {
        $r = Invoke-RestMethod -Method Post -Uri "$gateway/clientes" -Headers $headers -ContentType "application/json; charset=utf-8" -Body $bytes
        Write-Output "Cliente creado: $($r.nombre) (id=$($r.id))"
    } catch {
        Write-Output "ERROR cliente '$($cliente.nombre)': $($_.Exception.Message)"
    }
}
