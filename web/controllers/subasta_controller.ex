defmodule IascSubastas.SubastaController do
  use IascSubastas.Web, :controller

  alias IascSubastas.Subasta
  alias IascSubastas.SubastaWorker

  def index(conn, _params) do
      render conn, "index.html"
    # subastas = Repo.all from s in Subasta, preload: [:mejor_oferta]
    # render(conn, "index.json", subastas: subastas)
  end

  def cliente(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"subasta" => subasta_params}) do
    changeset = Subasta.changeset(%Subasta{mejor_oferta: nil}, subasta_params)

    case Repo.insert(changeset) do
      {:ok, subasta} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", subasta_path(conn, :show, subasta))
        |> render("show.json", subasta: subasta)
        # Notificar al worker
        # GenServer.cast(SubastaWorker, {:nueva_subasta, subasta.id})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(IascSubastas.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    subasta = Repo.get!(Subasta, id) |> Repo.preload(:mejor_oferta)
    render(conn, "show.json", subasta: subasta)
  end

  def update(conn, %{"id" => id, "subasta" => subasta_params}) do
    subasta = Repo.get!(Subasta, id) |> Repo.preload(:mejor_oferta)
    changeset = Subasta.changeset(subasta, subasta_params)

    case Repo.update(changeset) do
      {:ok, subasta} ->
        render(conn, "show.json", subasta: subasta)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(IascSubastas.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def cancelar(conn, %{"subasta_id" => id}) do
    subasta = Repo.get!(Subasta, id) |> Repo.preload(:mejor_oferta)
    changeset = Subasta.changeset(subasta, %{terminada: true})

    case Repo.update(changeset) do
      {:ok, subasta} ->
        render(conn, "show.json", subasta: subasta)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(IascSubastas.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    subasta = Repo.get!(Subasta, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(subasta)

    send_resp(conn, :no_content, "")
  end
end
