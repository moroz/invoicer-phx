defmodule Invoicer.FilenameHelpers do
  def sanitize_filename(filename) when is_binary(filename) do
    filename
    |> remove_unprintable_chars()
    |> replace_path_forbidden_chars()
    |> truncate_name_segment()
    |> String.trim(".")
  end

  def remove_unprintable_chars(string) when is_binary(string) do
    String.replace(string, ~r/[^ -~]/, "")
  end

  def replace_path_forbidden_chars(string) when is_binary(string) do
    String.replace(string, ~r{[<>:"\\/?*|]+}, "-")
  end

  defp truncate_name_segment(filename) do
    ext = Path.extname(filename)

    base =
      filename
      |> Path.basename(ext)
      |> String.trim()
      |> String.slice(0..96)

    base <> ext
  end
end
