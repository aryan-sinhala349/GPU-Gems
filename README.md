# Chapter 1. Effective Water Simulation from Physical Models
> This chapter describes a system for simulating and rendering large bodies of water on the GPU. The system combines geometric undulations of a base mesh with generation of a dynamic normal map.

## Goals and Scope
> We start with summing simple sine functions, then progress to slightly more complicated functions, as appropriate. We also extend the technique into the realm of pixel shaders, using a sum of periodic wave functions to create a dynamic tiling bump map to capture the finer details of the water surface.

## The Sum of Sines
This example uses two surface simulations: the geometric undulation of the surface mesh and the rippes in the normal map of that mesh. Both are represented by the sum of simple periodic waves, such as sine waves. The *sum of sines* gives a continuous function that describes the height and the surface orientation of the water at all points. In processing vertices, we sample that function based on the horizontal position of each vertex, conforming the mesh to the limits of its tesselation to the continuous water surface.