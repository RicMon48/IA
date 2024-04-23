import scipy
import numpy as np
import random
from scipy.sparse import coo_matrix
import networkx as nx

entradas=[1,1,2,2,2,3,3,3,4,4,
          5,5,5,6,6,6,6,7,7,7,
          7,8,8,8,8,9,9,9,9,9,
          9,10,10,10,11,11,11,11,12,12,
          12,12,13,13,13,13,14,14,14,14,
          15,15,15,15,16,16,16,17,17,17,
          17,18,18,18,18,19,19,20,20,20,
          21,21,22,22,22,22,23,23,23,23,
          24,24,24,25,25,25,26,26,26,27,
          27,27,28,28,28,28]

salidas=[2,5,1,3,22,2,4,22,3,23,
         1,11,6,5,25,7,12,6,26,13,
         8,7,13,14,9,8,13,18,27,10,
         17,9,21,20,5,12,17,19,6,13,
         17,11,12,7,8,9,8,28,15,18,
         14,28,24,16,24,15,18,11,12,9,
         20,9,14,16,27,11,20,19,17,10,
         10,27,2,3,25,23,22,4,24,28,
         23,15,16,22,26,6,25,28,7,9,
         18,21,26,23,15,14]

peso=[6,4,6,2,2,2,2,2,2,3,
      4,5,7,7,1,1,2,1,1,2,
      3,3,2,2,2,2,3,1,2,6,
      3,6,2,3,5,6,3,3,2,1,
      3,6,1,2,2,3,2,1,1,2,
      1,1,3,6,3,6,5,3,3,2,
      4,1,2,5,1,3,3,3,4,3,
      2,6,2,2,2,3,3,3,3,2,
      3,3,3,2,1,1,1,3,1,2,
      1,6,3,2,1,1]

# We create an undirected graph
G = nx.Graph()

# Agregamos nodos
G.add_nodes_from(entradas)

for i in range(len(entradas)):
    G.add_edge(entradas[i], salidas[i], weight=peso[i])

Adjacency = nx.adjacency_matrix(G).todense()

def is_valid_route(route, num_nodes):
    # Check if all nodes are visited exactly once
    visited = set()
    for node in route:
        if node in visited:
            return False  # Duplicate node, path is invalid
        visited.add(node)
    
    # Check if all nodes have been visited
    if len(visited) != num_nodes:
        return False  # Not all nodes were visited
    
    return True

def correct_route(route, num_nodes):
    # If the path is invalid, correct it
    if not is_valid_route(route, num_nodes):
        # Correct the path as desired, for example by removing duplicates and adding missing nodes
        corrected_route = list(set(route))
        while len(corrected_route) < num_nodes:
            missing_node = next((node for node in range(num_nodes) if node not in corrected_route), None)
            corrected_route.append(missing_node)
        return corrected_route
    else:
        return route

def get_route(start, end, matriz):
    path = [start]
    current_node = start
    visited = {start}
    total_cost = 0

    while current_node != end:
        # Get the nodes adjacent to the current node
        neighbors = np.nonzero(matriz[current_node])[1]
        # Delete already visited nodes
        neighbors = [neighbor for neighbor in neighbors if neighbor not in visited]

        if not neighbors:
            # If there are no unvisited adjacent nodes, roll back
            path.pop()
            current_node = path[-1]
        else:
            # Select a random node from unvisited neighbors
            next_node = random.choice(neighbors)
            visited.add(next_node)
            path.append(next_node)
            total_cost += matriz[current_node, next_node]
            current_node = next_node

    return path, total_cost


def crossover(path1, path2, probability):
    # Check if there is a last node in common
    common_node, common_position = common_nodes(path1, path2)
    if common_node is None:
        # There is no last node in common, no crossover is performed
        return path1, path2

   # Find the position of a node different from the last node in common
    different_node_position = None
    for i, node in enumerate(path1[common_position:]):
        if node not in path2[common_position:]:
            different_node_position = common_position + 1 + i
            break

    if different_node_position is None:
        # No node different from the last node in common was found, no traversal is performed
        return path1, path2

    # Applies probability to determine if the crossover is made
    if random.random() > probability:
        return path1, path2

# Performs the crossover by exchanging the subpaths between the parents from the position of the different node
    offspring1 = path1[:different_node_position] + path2[different_node_position:]
    offspring2 = path2[:different_node_position] + path1[different_node_position:]
    if((correct_route(offspring1,len(offspring1)))and(correct_route(offspring2,len(offspring2)))):
        return offspring1, offspring2

def common_nodes(path1, path2):
    """Encuentra el primer nodo diferente al último nodo en común entre las dos rutas."""
    common_node = None
    different_position = None
    for i, node in enumerate(path1):
        if node in path2 and i != len(path1) - 1:
            common_node = node
        elif common_node is not None:
            different_position = i
            break

    return common_node, different_position

#First try
ruta, costo = get_route(0, 14, Adjacency)
print("Ruta seleccionada:", ruta)
print("Costo total de la ruta:", costo)

def population(n_pop, Adjacency):
    population = []
    for i in range(n_pop):
        # Generate a child and add it to the population
        ruta, costo = get_route(0, 14, Adjacency)
        population.append((ruta, costo))  # Save the route and its cost as a tuple

    # Order the population from smallest to largest with respect to the cost of each route
    population_sorted = sorted(population, key=lambda x: x[1])

    return population_sorted



def fitness(route, matriz):
    total_cost = 0
    for i in range(len(route) - 1):
        total_cost += matriz[route[i], route[i+1]]
    return total_cost

def mutate(route, probability):
    mutated_route = route.copy()
    for i in range(1, len(mutated_route) - 1):  # Do not mutate the start or end node
        if random.random() < probability:
            # Select a new random node different from the original node
            new_node = random.choice([node for node in range(len(mutated_route)) if node != mutated_route[i]])
            new_route, _ = get_route(new_node, 14, Adjacency)
            if(correct_route(new_route,len(new_route))==True):
                mutated_route[i] = random.choice(new_route)
    return mutated_route

# Genetic algorithm parameters
n_pop = 3  # Population size
n_generations = 2   # Number of generations
mutation_prob = 0.1  # Mutation probability
crossover_prob = 0.3  #Crossover probability

# Creation of the initial population
population = population(n_pop, Adjacency)

#Genetic algorithm main loop
for _ in range(n_generations):
    # Assessment of the fitness of the current population
    fitness_values = [(route, fitness(route, Adjacency)) for route, _ in population]
    # Sort the population in descending order based on cost
    sorted_population = sorted(population, key=lambda x: x[1], reverse=True)

   # Selection of parents with higher cost
    parent1 = sorted_population[0][0]  # The first item will have the highest cost
    parent2 = sorted_population[1][0]  # The second item will have the second highest cost


    # Crossover and mutation to generate children
    child1, child2 = crossover(parent1, parent2, crossover_prob)
    child1 = mutate(child1, mutation_prob)
    child2 = mutate(child2, mutation_prob)

    # Replacement of the current population with children
    population = [(child1, fitness(child1, Adjacency)), (child2, fitness(child2, Adjacency))]

# Getting the best route after all generations
best_route, best_fitness = min(population, key=lambda x: x[-1])
print("Mejor ruta encontrada:", best_route)
print("Costo de la mejor ruta:", best_fitness)