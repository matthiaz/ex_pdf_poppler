defmodule ExPdfPopplerTest do
  use ExUnit.Case

  @test_path Path.join(__DIR__, "assets/sample.pdf")

  test "extract_text/2 extract text from pdf file" do
    assert {:ok,
            "This image is placed at an effective resolution of 16.7dpi\nImage and text may appear slightly different between pages\n\fThis image is placed at an effective resolution of 16.7dpi\nImage and text may appear slightly different between pages\n\f"} =
             ExPdfPoppler.extract_text(@test_path)
  end

  test "split/2 split pdf with multiple pages into multiple pdfs based on a pattern" do
    assert {:ok, splitted_files} =
             ExPdfPoppler.split(@test_path, Path.join(__DIR__, "assets/sample_splitted_%04d.pdf"))

    assert 2 = Enum.count(splitted_files)
    cleanup(splitted_files)
  end

  test "unit/2 unite multiple pdfs, into 1 big one" do
    # split file into multiple parts
    assert {:ok, splitted_files} =
             ExPdfPoppler.split(@test_path, Path.join(__DIR__, "assets/sample_splitted_%04d.pdf"))

    # now merge them back into one
    # pdfunite [options] <PDF-sourcefile-1>..<PDF-sourcefile-n> <PDF-destfile>
    dest_file = Path.join(__DIR__, "assets/sample_merged.pdf")
    assert {:ok, dest_file} = ExPdfPoppler.unite(splitted_files, dest_file)
    cleanup([dest_file | splitted_files])
  end

  # cleanup files that were used in the tests
  defp cleanup(splitted_files) do
    Enum.each(splitted_files, fn f ->
      System.cmd("rm", ["-f", f])
    end)
  end
end
