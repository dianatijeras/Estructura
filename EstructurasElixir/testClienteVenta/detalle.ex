defmodule Detalle do
  defstruct producto: %Producto{}, cantidad: 0

  def calcular_subtotal(%Detalle{producto: producto, cantidad: cantidad}) do
    producto.precio * cantidad
  end

  def crear(producto, cantidad) do
    %Detalle{producto: producto, cantidad: cantidad}
  end

  def escribir_csv(list_productos, nombre_archivo) do
    headers = "producto, cantidad\n"

    contenido =
      Enum.map(list_productos,
        fn %Producto{nombre: nombre, precio: precio} ->
          "#{nombre}, #{precio}\n"
        end)
      |> Enum.join()

    File.write(nombre_archivo, headers <> contenido)
  end

  def leer_csv(nombre_archivo) do # Funcion para leer archivo

    case File.read(nombre_archivo) do # Case para manejar errores
      {:ok, contenido} -> # Correcta lectura
        String.split(contenido, "\n") # Separa linea por linea
        |> Enum.map(fn line -> #Recorrer cada linea
          case String.split(line, ", ") do # Separa informacion por coma
            ["Nombre", "precio"] -> nil # Ignorar headers
            [nombre, precio] -> #Verificar pattern maching
              %Producto{nombre: nombre, precio: String.to_float(precio)} # Crear struct
            _ -> nil
          end
        end)
          |> Enum.filter(& &1) # Filtra nil y falsy values

      {:error, reason} -> # Error al leer
        IO.puts("Error al leer el archivo: #{reason}")
        []
    end
  end

end
