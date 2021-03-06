defmodule IascSubastas.SubastaTest do
  use IascSubastas.ModelCase

  alias IascSubastas.Subasta

  @valid_attrs %{precio_base: "120.5", duracion: 42, titulo: "some content", terminada: false, vendedor: "vendedor"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Subasta.changeset(%Subasta{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Subasta.changeset(%Subasta{}, @invalid_attrs)
    refute changeset.valid?
  end
end
