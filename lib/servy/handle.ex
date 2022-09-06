defmodule Servy.Handle do
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  def parse(conv) do
    [method, path, _]
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")
    %{method: method, path: path, resp_body: ""}
  end

  def route(conv) do
  end

  def format_response(conv) do
  end

  request = """
  GET /wildthings HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept: */*

  """
end
