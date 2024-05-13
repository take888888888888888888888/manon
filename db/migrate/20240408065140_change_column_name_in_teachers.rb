class ChangeColumnNameInTeachers < ActiveRecord::Migration[7.1]
  def change
    rename_column :teachers, :teachername, :teacher
  end
end
