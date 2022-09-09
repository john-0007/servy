defmodule Servy.Handle do
  alias Servy.Conv
  import Servy.Plugins, only: [rewrite_path: 1]
  import Servy.Parser, only: [parse: 1]

  @pages_path Path.expand("pages", File.cwd!())

  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> route()
    |> format_response()
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%Conv{method: "POST", path: "/beas"} = conv) do
    %{conv | status: 201, resp_body: "Create a #{conv.params["type"]} bear named #{conv.params["name"]"}
  end

  def route(%Conv{method: "GET", path: "/bear" <> id} = conv) do
    %{conv | status: 200, resp_body: "bear #{id}"}
  end

  def route(%Conv{method: "GET", path: "/bear/new"} = conv) do
    file =
      @pages_path
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

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    file =
      @pages_path
      |> Path.join(file <> ".html")

    case File.read(file) do
      {:ok, content} ->
        %{conv | status: 200, resp_body: content}

      {:error, :enoent} ->
        %{conv | status: 404, resp_body: "File not found"}

      {:error, reason} ->
        %{conv | status: 500, resp_body: reason}
    end
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    file =
      @pages_path
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

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}""
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end
