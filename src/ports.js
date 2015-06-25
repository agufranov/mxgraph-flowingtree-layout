prts = function(graph) {
				graph.getAllConnectionConstraints = function(terminal)
				{
					if (terminal != null && this.model.isVertex(terminal.cell))
					{
						return [];
            // [new mxConnectionConstraint(new mxPoint(0, 0), true),
						// 	new mxConnectionConstraint(new mxPoint(0.1, 1), true)];
					}

					return null;
				};
				
				// Connect preview for elbow edges
				graph.connectionHandler.createEdgeState = function(me)
				{
					var edge = graph.createEdge(null, null, null, null, null, 'edgeStyle=elbowEdgeStyle');
					
					return new mxCellState(this.graph.view, edge, this.graph.getCellStyle(edge));
				};

				// Disables floating connections
				graph.connectionHandler.isConnectableCell = function(cell)
				{
				   return false;
				};
				mxEdgeHandler.prototype.isConnectableCell = function(cell)
				{
					return graph.connectionHandler.isConnectableCell(cell);
				};
}
