import json

import matplotlib.pyplot as plt
import numpy as np

translations = {
    "least_connections": "Menos Conexões",
    "round_robin": "Round Robin",
    "weighted_least_connections": "Menos Conexões Ponderado",
    "weighted_round_robin": "Round Robin Ponderado",
    "least_response_time": "Menor Tempo de Resposta",
}

file = open("results.json")

contents = json.load(file)

# Bar plot, total requests
for algorithm in contents.items():
    workers = ["Worker 1", "Worker 2", "Worker 3"]

    data_by_scenario = {}

    title_counter = 1

    for scenario in algorithm[1].items():
        data_by_scenario[f"Cenário {title_counter}"] = [
            worker["total_blocks"] for worker in scenario[1]["metrics"].values()
        ]
        title_counter += 1
    x = np.arange(len(workers))
    width = 0.20
    multiplier = 0

    fig, ax = plt.subplots(layout="constrained")

    y_lim = 0

    for attribute, measurement in data_by_scenario.items():
        max_height = max(measurement)
        if max_height > y_lim:
            y_lim = max_height
        offset = width * multiplier
        rects = ax.bar(x + offset, measurement, width, label=attribute)
        ax.bar_label(rects, padding=3)
        multiplier += 1

    # Add some text for labels, title and custom x-axis tick labels, etc.
    ax.set_ylabel("Total de blocos")
    ax.set_title(f"{translations[algorithm[0]]}")
    ax.set_xticks(x + width, workers)
    ax.legend(loc="upper left", ncols=4)
    ax.set_ylim(0, y_lim + 10)

    plt.show()
