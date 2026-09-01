$ErrorActionPreference = "Stop"

$clientes = @(
    @{ nombre = "Juan Pérez"; email = "juan.perez@mail.com"; telefono = "600111222" },
    @{ nombre = "María López"; email = "maria.lopez@mail.com"; telefono = "600333444" },
    @{ nombre = "Carlos Ruiz"; email = "carlos.ruiz@mail.com"; telefono = "600555666" }
)

foreach ($cliente in $clientes) {
    $json = $cliente | ConvertTo-Json
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    try {
        $r = Invoke-RestMethod -Method Post -Uri "http://localhost:8080/clientes" -ContentType "application/json; charset=utf-8" -Body $bytes
        Write-Output "Cliente creado: $($r.nombre) (id=$($r.id))"
    } catch {
        Write-Output "ERROR cliente '$($cliente.nombre)': $($_.Exception.Message)"
    }
}
