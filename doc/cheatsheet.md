# OpenGL Cheatsheet

## Initialisation

1. Include the needed libraries

```cpp
#include "../include/glad/glad.h"
#include <GLFW/glfw3.h>
```

2. Init OpenGL and configure it (in this example we use OpenGL version 3.3 using the core-profile)

```cpp
glfwInit();
glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
```

3. Create a window and make the context of `window` the main context of the current thread

```cpp
GLFWwindow* window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
if (window == NULL)
{
    std::cout << "Failed to create GLFW window" << std::endl;
    glfwTerminate();
    return -1;
}
glfwMakeContextCurrent(window);
```

4. Load GLAD

```cpp
if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
{
    std::cout << "Failed to initialize GLAD" << std::endl;
    return -1;
}
```

5. Set the Viewport and set the callback function when the window is resized

```cpp
void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
    glViewport(0, 0, width, height);
}

int main {
    [...] // Previous steps here
    glViewport(0, 0, 800, 600);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
}
```

6. Create the main loop

```cpp
while(!glfwWindowShouldClose(window))
{
    glfwSwapBuffers(window);
    glfwPollEvents();
}
```

7. Properly clean and delete all of GLFW's ressources

```cpp
glfwTerminate();
```

8. (Optional) Process input

```cpp
[...]
void processInput(GLFWwindow *window) {
    if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, true);
    }
}

int main {
    [...]
    while(!glfwWindowShouldClose(window))
    {
        processInput(window); // <--------


        glfwSwapBuffers(window);
        glfwPollEvents();
    }
    glfwTerminate();
    return 0;
}
```

## Define the shader program (should add success check)

### Vertex Shader

1. Save the vertex shader code in a string

```cpp
// OpenGL version
# version 330 core

// Input
layout (location = 0) in vec3 aPos;

void main() {
    // Output
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
```

```cpp
const char *vertexShaderSource = "#version 330 core\n"
    "layout (location = 0) in vec3 aPos;\n"
    "void main()\n"
    "{\n"
    "    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
    "}\0";
```

2. Compile the vertex shader

```cpp
unsigned int getVertexShader() {
    unsigned int vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);

    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if(!success)
    {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    return vertexShader;
}
```

### Fragment Shader

1. Save the vertex shader code in a string

```cpp
const char *fragmentShaderSource = "#version 330 core\n"
    "out vec4 FragColor;\n"
    "void main()\n"
    "{\n"
    "    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
    "}\n";
```

2. Compile the fragment shader

```cpp
unsigned int getFragmentShader() {
    unsigned int fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);

    int success;
    char infoLog[512];
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if(!success)
    {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    return fragmentShader;
}
```

## Link the shaders into a program

```cpp
unsigned int vertexShader = getVertexShader();
unsigned int fragmentShader = getFragmentShader();
unsigned int shaderProgram;
shaderProgram = glCreateProgram();
glAttachShader(shaderProgram, vertexShader);
glAttachShader(shaderProgram, fragmentShader);
glLinkProgram(shaderProgram);
glUseProgram(shaderProgram);

// Delete the shaders after linking
glDeleteShader(vertexShader);
glDeleteShader(fragmentShader);
```


## Drawing something

### Triangle

#### Using VBO and vertex attributes

```cpp
// Generate an OpenGL vertex buffer
unsigned int VBO;
glGenBuffers(1, &VBO);
// Bind the array buffer to our buffer
glBindBuffer(GL_ARRAY_BUFFER, VBO);
// Copy our data to the buffer
glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
// Set our vertex attributes pointers
glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
glEnableVertexAttribArray(0);

while(!glfwWindowShouldClose(window)) {
    [...]
    // 0. copy our vertices array in a buffer for OpenGL to use
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    // 1. then set the vertex attributes pointers
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    // 2. use our shader program when we want to render an object
    glUseProgram(shaderProgram);
    // 3. now draw the object
    glDrawArrays(GL_TRIANGLES, 0, 3);
    [...]
}
```

### Using VBO and VAO

```cpp
// Generate an OpenGL vertex buffer object and vertex array object
unsigned int VBO;
glGenBuffers(1, &VBO);
unsigned int VAO;
glGenVertexArrays(1, &VAO);

// Bind the array buffer to our buffer
glBindBuffer(GL_ARRAY_BUFFER, VBO);
// Bind the vertex array
glBindVertexArray(VAO);

// Copy our data to the buffer
glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

// Set our vertex attributes pointers
glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
glEnableVertexAttribArray(0);


while(!glfwWindowShouldClose(window)) {
    [...]
    glUseProgram(shaderProgram);
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    [...]
}
```


### Using Element (Index) Buffer

```cpp
float vertices[] = {
     0.5f,  0.5f, 0.0f,  // top right
     0.5f, -0.5f, 0.0f,  // bottom right
    -0.5f, -0.5f, 0.0f,  // bottom left
    -0.5f,  0.5f, 0.0f   // top left
};
unsigned int indices[] = {  // note that we start from 0!
    0, 1, 3,   // first triangle
    1, 2, 3    // second triangle
};

[...]

// Generate the VBO, VAO and element buffer object
unsigned int VBO;
glGenBuffers(1, &VBO);
unsigned int VAO;
glGenVertexArrays(1, &VAO);
unsigned int EBO;
glGenBuffers(1, &EBO);

// Bind the array buffer to our vertex buffer
glBindBuffer(GL_ARRAY_BUFFER, VBO);
// Bind the vertex array to our vertex array buffer
glBindVertexArray(VAO);
// Bind the element array buffer to our element buffer
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);

// Copy our vertices array in a vertex buffer for OpenGL to use
glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
// Copy our index array in an element buffer for OpenGL to use
glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

// Set our vertex attributes pointers
glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
glEnableVertexAttribArray(0);


while(!glfwWindowShouldClose(window)) {
    [...]
    glUseProgram(shaderProgram);
    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    glBindVertexArray(0);
    [...]
}
```

