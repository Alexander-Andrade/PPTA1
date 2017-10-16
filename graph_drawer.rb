require "graphviz"

class GraphDrawer

  def initialize(fsm, path)
    @fsm = fsm
  end

  def output(filename)
    @graph = GraphViz::new( "G", "path" => path )
    @graph.node["shape"] = "circle"

    @fsm.F.keys.each do |col_nonterm|
      @fsm.F[col_nonterm].keys.each do |term|

      end
    end

    @graph.output(png: "#{filename}.png" )
  end

end