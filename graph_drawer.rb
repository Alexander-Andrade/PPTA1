require "graphviz"

class GraphDrawer

  def initialize(fsm)
    @fsm = fsm
  end

  def output(filename)
    @graph = GraphViz::new( "G", "path" => ARGV[0] )
    @graph.node["shape"] = "circle"

    @fsm.Q.each { |state| @graph.add_nodes(state) }

    @fsm.F.keys.each do |col_nonterm|
      @fsm.F[col_nonterm].keys.each do |term|
        @graph.add_edges(col_nonterm,  @fsm.F[col_nonterm][term], "label" => term)
      end
    end

    @graph.output(png: "#{filename}.png" )
  end

end