class AddFullTextSearchToUnitesLegales < ActiveRecord::Migration[7.1]
  def up
    add_column :unite_legales, :tsvector_nom_tsearch, :tsvector

    execute <<-SQL
      UPDATE unite_legales SET tsvector_nom_tsearch = (
        setweight(to_tsvector('french', coalesce("denominationUniteLegale", '')), 'A') ||
        setweight(to_tsvector('french', coalesce("nomUniteLegale", '')), 'B')
      );
    SQL

    execute <<-SQL
      CREATE INDEX index_unite_legales_on_tsvector_nom_tsearch ON unite_legales USING GIN(tsvector_nom_tsearch);
    SQL

    execute <<-SQL
      DROP TRIGGER IF EXISTS unite_legales_tsvector_nom_tsearch_update ON unite_legales;
      CREATE TRIGGER unite_legales_tsvector_nom_tsearch_update BEFORE INSERT OR UPDATE ON unite_legales FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger(
        tsvector_nom_tsearch, 'french', "denominationUniteLegale", "nomUniteLegale"
      );
    SQL
  end

  def down
    remove_column :unite_legales, :tsvector_nom_tsearch, :tsvector

    execute "DROP TRIGGER IF EXISTS unite_legales_tsvector_nom_tsearch_update ON unite_legales;"
    execute "DROP INDEX IF EXISTS index_unite_legales_on_tsvector_nom_tsearch;"
  end
end
