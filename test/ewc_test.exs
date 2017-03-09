defmodule EwcTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  describe "CLI main" do
    test "works with an empty file" do
      assert cli_main(["fixtures/empty_test_file"]) == "\t0\t0\t0\tfixtures/empty_test_file\n"
    end

    test "works with a one line file" do
      assert cli_main(["fixtures/test_file_1"]) == "\t1\t5\t24\tfixtures/test_file_1\n"
    end

    test "works with a two line file" do
      assert cli_main(["fixtures/test_file_2"]) == "\t2\t9\t48\tfixtures/test_file_2\n"
    end

    test "only prints line count with -l" do
      assert cli_main(["-l", "fixtures/test_file_2"]) == "\t2\tfixtures/test_file_2\n"
    end

    test "only prints word count with -w" do
      assert cli_main(["-w", "fixtures/test_file_2"]) == "\t9\tfixtures/test_file_2\n"
    end

    test "only prints char count with -m" do
      assert cli_main(["-m", "fixtures/test_file_2"]) == "\t48\tfixtures/test_file_2\n"
    end

    test "prints line and word count with -lw" do
      assert cli_main(["-lw", "fixtures/test_file_2"]) == "\t2\t9\tfixtures/test_file_2\n"
    end

    test "prints line and char count with -lm" do
      assert cli_main(["-lm", "fixtures/test_file_2"]) == "\t2\t48\tfixtures/test_file_2\n"
    end

    test "prints word and char count with -wm" do
      assert cli_main(["-wm", "fixtures/test_file_2"]) == "\t9\t48\tfixtures/test_file_2\n"
    end

    test "print everything if there are no flags" do
      assert cli_main(["-lwm", "fixtures/test_file_2"]) == cli_main(["fixtures/test_file_2"])
    end
  end

  defp cli_main(args), do: capture_io(fn -> Ewc.CLI.main(args) end)
end
