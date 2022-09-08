defmodule Servy.Handle do
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> route()
    |> format_response()
  end

  def parse(conv) do
    [method, path, _] =
      conv
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, status: nil, resp_body: ""}
  end

  def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(conv), do: conv

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/bear" <> id} = conv) do
    %{conv | status: 200, resp_body: "bear #{id}"}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    file =
      Path.expand("../../pages", __DIR__)
      |> Path.join("about.html")

    case File.read(file) do
      {:ok, content} ->
        %{conv | status: 200, resp_body: content}

      {:error, :enoent} ->
        %{conv | status: 404, resp_body: "File not found"}

      {:error, reason} ->
        %{conv | status: 500, resp_body: reason}
    end
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")
  #     |> File.read()
  #     |> handle_file(conv)
  # end

  # def handle_file({:ok, content}, conv)  do
  #   %{conv | status: 200, resp_body: content}
  # end

  # def handle_file({:error, :enoent} , conv)  do
  #   %{conv | status: 404, resp_body: "File not found"}
  # end

  # def handle_file({:error, reason} , conv)  do
  #   %{conv | status: 500, resp_body: reason}
  # end

  def route(conv, _method, path) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
