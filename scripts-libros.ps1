$ErrorActionPreference = "Stop"

$libros = @(
    @{ titulo = "Cien años de soledad"; autor = "Gabriel García Márquez"; isbn = "978-84-376-0494-7"; precio = 19.99; stock = 10 },
    @{ titulo = "1984"; autor = "George Orwell"; isbn = "978-84-206-6089-7"; precio = 15.50; stock = 25 },
    @{ titulo = "El principito"; autor = "Antoine de Saint-Exupéry"; isbn = "978-84-150-6015-0"; precio = 9.95; stock = 40 }
)

foreach ($libro in $libros) {
    $json = $libro | ConvertTo-Json
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    try {
        $r = Invoke-RestMethod -Method Post -Uri "http://localhost:8080/libros" -ContentType "application/json; charset=utf-8" -Body $bytes
        Write-Output "Libro creado: $($r.titulo) (id=$($r.id))"
    } catch {
        Write-Output "ERROR libro '$($libro.titulo)': $($_.Exception.Message)"
    }
}
