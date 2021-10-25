defmodule ElectionTest do

  use ExUnit.Case
  doctest Election

  # runs before each test
  setup do
    %{el: %Election{}}
  end

  # runs once for all tests
  # setup_all do

  # end

  # test recieves a description and a context, which we get from `setup` macro
  test "updating election name from a command", ctx do
    command = "name Will Ferrell"
    election = Election.update(ctx.el, command)
    assert election == %Election{name: "Will Ferrell"}
  end

  test "adding a new candidate from a command", ctx do
    command = "add Will Ferrell"
    want = %Election{
      candidates: [Candidate.new(1, "Will Ferrell")],
      next_id: 2
    }
    got = Election.update(ctx.el, command)
    assert got == want
  end

  test "voting for a candidate from a command", ctx do
    want = %Election{
      candidates: [%Candidate{id: 1, name: "Will Ferrell", votes: 1}],
      next_id: 2
    }
    got = ctx.el
      |> Election.update("add Will Ferrell")
      |> Election.update("vote 1")
    assert got == want
  end

  test "invalid command", ctx do
    command = "invalid command"
    got = Election.update(ctx.el, command)
    assert got == %Election{}
  end

  test "quitting the app", ctx do
    command = "q"
    got = Election.update(ctx.el, command)
    assert got == :quit
  end

end
