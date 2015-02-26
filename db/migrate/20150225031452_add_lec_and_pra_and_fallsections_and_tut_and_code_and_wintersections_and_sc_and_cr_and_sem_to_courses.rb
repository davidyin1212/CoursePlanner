class AddLecAndPraAndFallsectionsAndTutAndCodeAndWintersectionsAndScAndCrAndSemToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :Lec, :string
    add_column :courses, :Pra, :string
    add_column :courses, :Fallsections, :text
    add_column :courses, :Tut, :string
    add_column :courses, :Code, :string
    add_column :courses, :Wintersections, :text
    add_column :courses, :Sc, :string
    add_column :courses, :Cr, :string
    add_column :courses, :Sem, :string
  end
end
