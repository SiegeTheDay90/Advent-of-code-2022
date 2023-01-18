
from collections import deque
def build_span(spans):

    empty_indices = deque()
    # print(spans)

    for index, span in enumerate(spans):
        if len(span) == 0:
            empty_indices.appendleft(index)

    for index in empty_indices:
        spans.pop(index)

    spans = sorted(spans, key=lambda x: x[0], reverse=False)

    combined = []

    combined.append(spans.pop(0))
    # pdb.set_trace()
    for index, span in enumerate(spans):

        if combined[-1][-1]+1 >= spans[index][0]:
            if spans[index][-1] > combined[-1][-1]:
                combined[-1] = range(combined[-1][0], spans[index][-1]+2)
            else:
                continue
        else:
            combined.append(spans[index])
            

    
    return combined