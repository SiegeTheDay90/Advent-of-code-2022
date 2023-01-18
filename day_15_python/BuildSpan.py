def build_span(sensors, y):
    first = sensors.pop(0)
    spans = [first.x_bound]
    least = spans[0][0]
    most = spans[0][-1]

    while len(sensors):
        breaker = False
        current = sensors.pop(0)
        current_span = current.x_bound
        min_flag = [False, None]

        for idx, span in enumerate(spans):
            if current_span[0] in span:
                if current_span[-1] in span:
                    breaker = True
                    break
                else:
                    min_flag = [True, idx]
                    break
        
        if breaker:
            continue

        for idx, span in enumerate(spans):
            if current_span[-1] in span and min_flag[0]:
                spans.append(range(spans[min_flag[1]][0], span[-1]+1))
                if idx > min_flag[1]:
                    spans.pop(idx)
                    spans.pop(min_flag[1])
                elif idx < min_flag[1]:
                    spans.pop(min_flag[1])
                    spans.pop(idx)
                breaker = True
                break
            
            elif current_span[-1] in span:
                spans.append(range(current_span[0], span[-1]+1))
                spans.pop(idx)
                breaker = True
                break
        
        if breaker:
            continue

        spans.append(range(current_span[0], current_span[-1]+1))
        if current_span[0] < least and current_span[-1] > most:
            spans = [spans[-1]]
        if current_span[0] < least:
            least = current_span[0]
        if current_span[-1] > most:
            most = current_span[-1]

    return spans