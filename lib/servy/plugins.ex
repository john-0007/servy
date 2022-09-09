defmodule Servy.Plugins do
  def track(%{status: 404, path: path} = conv) do
    IO.puts("Wraning: #{path} is on the lose!")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect(conv)
end
