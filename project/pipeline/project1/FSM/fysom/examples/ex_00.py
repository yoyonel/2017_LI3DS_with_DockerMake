from fysom import *
import graphviz as gv

import functools

import itertools as it

graph = functools.partial(gv.Graph, format='png')
digraph = functools.partial(gv.Digraph, format='png')


def add_nodes(graph, nodes):
    for n in nodes:
        if isinstance(n, tuple):
            graph.node(n[0], **n[1])
        else:
            graph.node(n)
    return graph


def add_edges(graph, edges):
    for e in edges:
        if isinstance(e[0], tuple):
            graph.edge(*e[0], **e[1])
        else:
            graph.edge(*e)
    return graph


def apply_styles(graph, styles):
    graph.graph_attr.update(
        ('graph' in styles and styles['graph']) or {}
    )
    graph.node_attr.update(
        ('nodes' in styles and styles['nodes']) or {}
    )
    graph.edge_attr.update(
        ('edges' in styles and styles['edges']) or {}
    )
    if 'rankdir' in styles:
        graph.graph_attr['rankdir'] = styles['rankdir']

    return graph


def build_and_render_graph():
    g7 = add_edges(
        add_nodes(digraph(), [
            ('A', {'label': 'Node A'}),
            ('B', {'label': 'Node B'}),
            'C'
        ]),
        [
            (('A', 'B'), {'label': 'Edge 1'}),
            (('A', 'C'), {'label': 'Edge 2'}),
            ('B', 'C')
        ]
    )

    g8 = apply_styles(
        add_edges(
            add_nodes(digraph(), [
                ('D', {'label': 'Node D'}),
                ('E', {'label': 'Node E'}),
                'F'
            ]),
            [
                (('D', 'E'), {'label': 'Edge 3'}),
                (('D', 'F'), {'label': 'Edge 4'}),
                ('E', 'F')
            ]
        ),
        {
            'nodes': {
                'shape': 'square',
                'style': 'filled',
                'fillcolor': '#cccccc',
            }
        }
    )

    g7.subgraph(g8)
    g7.edge('B', 'E', color='red', weight='2')

    g7.render('img/p0204_7')


class FysomWithGraphViz(Fysom):
    def __init__(self, *args):
        """

        :param args:
        :param kwargs:
        """
        super(FysomWithGraphViz, self).__init__(*args)

        self.cfg_ = args[0]

    def build_graph_(self):
        """

        :return:
         :rtype: gv.Digraph
        """
        events = self.cfg_['events']

        src_dst = (
            (event['src'], event['dst'])
            for event in events
        )
        # url: http://stackoverflow.com/questions/952914/making-a-flat-list-out-of-list-of-lists-in-python
        nodes = set(it.chain(*src_dst))
        print("nodes: %s" % nodes)

        gv_nodes = [
            (node, {'label': node})
            for node in nodes
            ]
        print("gv_nodes: %s" % gv_nodes)

        gv_transitions = [
            ((event['src'], event['dst']),
             {'label': 'transition: %s' % event['name']})
            for event in events
            ]
        print("gv_transitions: %s" % gv_transitions)

        return add_edges(
            add_nodes(digraph(),
                      gv_nodes),
            gv_transitions
        )

    def render(self, img_name, style):
        """

        :param img_name:
        :type img_name: str
        :param style:
        :type style: dict
        """
        graph = self.build_graph_()
        gv = apply_styles(graph, style)
        gv.render(img_name)


def test_render_graphviz():
    # urls:
    # - https://pypi.python.org/pypi/graphviz/0.4.2
    # - http://graphviz.org/content/horizontal-graph
    # - https://martin-thoma.com/how-to-draw-a-finite-state-machine/
    # - http://matthiaseisen.com/pp/patterns/p0204/
    # - https://pythonspot.com/en/python-finite-state-machine/

    # fsm_digraph = digraph()
    # fsm_digraph.graph_attr['rankdir'] = 'LR'
    # graph_of_fsm = add_edges(
    #     add_nodes(fsm_digraph, [
    #         ('awake', {'label': 'awake'}),
    #         ('sleeping', {'label': 'sleeping'})
    #     ]),
    #     [
    #         (('sleeping', 'awake'), {'label': 'transition: wakeup'}),
    #         (('awake', 'sleeping'), {'label': 'transition: sleep'})
    #     ]
    # )
    graph_of_fsm = apply_styles(
        add_edges(
            add_nodes(digraph(), [
                ('awake', {'label': 'awake'}),
                ('sleeping', {'label': 'sleeping'})
            ]),
            [
                (('sleeping', 'awake'), {'label': 'transition: wakeup'}),
                (('awake', 'sleeping'), {'label': 'transition: sleep'})
            ]
        ),
        {
            'rankdir': 'LR'
        }
    )
    #
    graph_of_fsm.render('img/ex_00')


if __name__ == '__main__':
    fsm_cfg = {'initial': 'awake',
               'final': 'red',
               'events': [
                   {'name': 'wakeup', 'src': 'sleeping', 'dst': 'awake'},
                   {'name': 'sleep', 'src': 'awake', 'dst': 'sleeping'}]}

    # fsm = Fysom(fsm_cfg)
    fsm = FysomWithGraphViz(fsm_cfg)

    print(fsm.current)  # awake
    fsm.sleep()
    print(fsm.current)  # sleeping
    fsm.wakeup()
    print(fsm.current)  # awake

    test_render_graphviz()

    fsm.render('img/ex_00_autogen',
               {'rankdir': 'LR'})
