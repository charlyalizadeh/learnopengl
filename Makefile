build:
	mkdir -p ./bin

hellotriangle_main:
	g++ -o bin/hellotriangle_main src/GettingStarted/HelloTriangle/main.cpp src/glad.c -I ./include/glad/ -lglfw

hellotriangle_ex1:
	g++ -o bin/hellotriangle_ex1 src/GettingStarted/HelloTriangle/ex1.cpp src/glad.c -I ./include/glad/ -lglfw

hellotriangle_ex2:
	g++ -o bin/hellotriangle_ex2 src/GettingStarted/HelloTriangle/ex2.cpp src/glad.c -I ./include/glad/ -lglfw

hellotriangle_ex3:
	g++ -o bin/hellotriangle_ex3 src/GettingStarted/HelloTriangle/ex3.cpp src/glad.c -I ./include/glad/ -lglfw

hellotriangle: hellotriangle_ex1 hellotriangle_ex2 hellotriangle_ex3
