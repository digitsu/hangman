defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordList

  @name __MODULE__
  use Agent

  @type t :: pid()

  @spec random_word() :: WordList.t
  def random_word() do
    Agent.get(@name, &WordList.random_word/1)
  end

  @spec start_link(list) :: t
  def start_link(_arg) do
    Agent.start_link(&WordList.word_list/0, name: @name)
  end
end