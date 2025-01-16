defmodule ExPdfPoppler do
  @moduledoc """
  Documentation for `ExPdfPoppler`.
  """
  require Logger

  @doc """
  Extracts text from a PDF file using Poppler's pdftotext tool.
  """
  def extract_text(file_path, opts \\ []) do
    cmd_args = [file_path, "-", "-raw"] ++ opts

    exec("pdftotext", cmd_args)
  end

  @doc """
  see unite
  """
  def merge(source_files, destination_file, opts \\ []) do
    unite(source_files, destination_file, opts)
  end

  def merge!(source_files, destination_file, opts \\ []) do
    unite!(source_files, destination_file, opts)
  end

  @doc """
  Merge different pdf files into one big file
  Equivilant of : pdfunite [options] <PDF-sourcefile-1>..<PDF-sourcefile-n> <PDF-destfile>
  """
  def unite(source_files, destination_file, opts \\ []) do
    cmd_args = source_files ++ [destination_file] ++ opts
    {:ok, _} = exec("pdfunite", cmd_args)
    {:ok, destination_file}
  end

  def unite!(source_files, destination_file, opts \\ []) do
    case unite(source_files, destination_file, opts) do
      {:ok, destination_file} ->
        destination_file

      {:error, reason} ->
        raise ExPdfPoppler.Error,
          reason: reason,
          action: "unite"
    end
  end

  @doc """
  Solit a PDF file with multiple pages into separate PDF files, 1 per page
  Equivilant of : pdfseparate [options] <PDF-sourcefile> <PDF-pattern-destfile>
  dest_file_pattern uses sprintf notation. For example: path/to/destination_filename-%04d.pdf
  """
  def split(source_file, dest_file_pattern, opts \\ []) do
    cmd_args = [source_file, dest_file_pattern] ++ opts
    {:ok, _output} = exec("pdfseparate", cmd_args)
    {:ok, Path.wildcard(dest_file_pattern |> String.replace(~r"%[0-9]*d", "*"))}
  end

  def split!(source_file, dest_file_pattern, opts \\ []) do
    case split(source_file, dest_file_pattern, opts) do
      {:ok, list_of_files_created} ->
        list_of_files_created

      {:error, reason} ->
        raise ExPdfPoppler.Error,
          reason: reason,
          action: "split"
    end
  end


  defp exec(cmd, cmd_args) do
    if is_poppler_installed?() do
      Logger.debug("Executing command: #{cmd} #{inspect(cmd_args)}")
      {output, exit_code} = System.cmd(cmd, cmd_args)

      if exit_code == 0 do
        {:ok, output}
      else
        {:error, "Failed to run cmd #{cmd} on PDF file"}
      end
    else
      {:error, "Poppler is not installed or accessible. Please install the poppler package."}
    end
  end

  defp is_poppler_installed?() do
    # sudo dnf install poppler
    case System.cmd("pdfunite", ["-v"]) do
      {_, 0} -> true
      _ -> false
    end
  end
end
