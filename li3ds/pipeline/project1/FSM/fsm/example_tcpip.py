#!/usr/bin/python

from fsm import finitestatemachine, get_graph, state

states = ['listen', 'syn rcvd', 'established', 'syn sent',
          'fin wait 1', 'fin wait 2', 'time wait', 'closing', 'close wait',
          'last ack']

tcpip = finitestatemachine('tcp ip')

closed = state('closed', initial=true)
listen, synrcvd, established, synsent, finwait1, finwait2, timewait, \
closing, closewait, lastack = [state(s) for s in states]

timewait['(wait)'] = closed
closed.update({r'passive\nopen': listen,
               'send syn': synsent})

synsent.update({r'close /\ntimeout': closed,
                r'recv syn,\nsend\nsyn+ack': synrcvd,
                r'recv syn+ack,\nsend ack': established})

listen.update({r'recv syn,\nsend\nsyn+ack': synrcvd,
               'send syn': synsent})

synrcvd.update({'recv ack': established,
                'send fin': finwait1,
                'recv rst': listen})

established.update({'send fin': finwait1,
                    r'recv fin,\nsend ack': closewait})

closewait['send fin'] = lastack

lastack['recv ack'] = closed

finwait1.update({'send ack': closing,
                 'recv ack': finwait2,
                 r'recv fin, ack\n send ack': timewait})

finwait2[r'recv fin,\nsend ack'] = timewait

closing[r'recv\nack'] = timewait

graph = get_graph(tcpip)
graph.draw('tcp.png', prog='dot')
