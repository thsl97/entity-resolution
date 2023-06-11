import json

import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np

translations = {
    "least_connections": "Menos Conexões",
    "round_robin": "Round Robin",
    "weighted_least_connections": "Menos Conexões Ponderado",
    "weighted_round_robin": "Round Robin Ponderado",
    "least_response_time": "Menor Tempo de Resposta",
    "best_case": "Cenário 1",
    "median_case_1": "Cenário 2",
    "median_case_2": "Cenário 3",
    "worst_case": "Cenário 4",
}

file = open("results.json")

contents = json.load(file)

# Bar plot, total requests per scenario
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

    # Line chart for chunk processing time
    for scenario in algorithm[1].items():
        worker_index = 0
        min_elem = 0
        max_elem = 0
        for worker in scenario[1]["metrics"].items():
            y_axis = worker[1]["execution_times"]
            y_axis.reverse()
            max_height = max(y_axis)
            if max_height > 60000:
                time_unit = "m"
                y_axis = np.array(y_axis) / 60000
            elif max_height > 1000:
                time_unit = "s"
                y_axis = np.array(y_axis) / 1000
            else:
                time_unit = "ms"
            x_axis = [x for x in range(1, len(y_axis) + 1)]
            max_from_y = max(y_axis)
            min_from_y = min(y_axis)
            if max_from_y > max_elem:
                max_elem = max_from_y
            plt.plot(x_axis, y_axis, label=workers[worker_index])
            worker_index += 1
        ax = plt.gca()  # Get the current axis
        ax.yaxis.set_major_locator(ticker.MaxNLocator(integer=True))
        plt.xlabel(f"Blocos")
        plt.ylabel(f"Tempo ({time_unit})")
        plt.title(f"{translations[algorithm[0]]} - {translations[scenario[0]]}")
        plt.legend()

        plt.show()
