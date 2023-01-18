def build_span(spans):
    
    indices = []
    for index, span in enumerate(spans):

        if len(span) == 0:
            indices.append(index)
            continue

    for index in reversed(sorted(indices)):
        spans.pop(index)

    if len(spans) == 0:
        return [range(0,0)]


    least = float('inf')
    most = float('-inf')
    indices = dict()

    for index, span in enumerate(span):
        if span[0] < least:
            least = span[0]
            indices['least'] = index

        if span[-1] > most:
            most = span[-1]
            indices['most'] = index

    return spans