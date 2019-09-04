
# DepthMap generation on FPGA

```diff
- This project is still in Progress
```


Most of the image processing projects in academia has been done on higher-end FPGA's with a considerable amount of resources. The main objective of this project is to implement a reliable embedded system on a lower end FPGA with limited resources. This project is based on Disparity calculation based on SAD (Sum of Absolute Difference) algorithm and creating a depth map.

<img width="300" height="200" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/basys3.png" align="right">
<img width="200" height="200" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/ov7670.jpg" align="right">

Hardware used for this project

 - Basys 3 FPGA board
 - 2x OV7670 image sensor modules
 <br/>
<br/>
<br/>
<br/>

This project has 3 major sections

 1. [Functional verification of disparity generator based on Verilog](https://github.com/Archfx/FPGA_depthMap)
 2. [Stereo camera implementation using OV7670 sensors based on VHDL](https://github.com/Archfx/FPGA-stereo-Camera-Basys3)
 3. [Real time disparity generation on Basys3 FPGA](https://github.com/Archfx/FPGA-DepthMap-Basys3)


## Functional verification

Hardware description languages(HDL) are not meant to be for rapid prototyping. Therefore, in this case, I have used python as the prototyping tool. The SAD algorithm was implemented on python from scratch without using any external library. I refrained from using 2D image arrays to store data because then the HDL implementation is straight forward.

**SAD theory** 

Sum of Absolute difference is based on a simple geometric concept. Where they use the stereo vision to calculate the distance to the objects. For the implementation, two cameras should be on the same plane and they should not have any vertical offsets in their alignments.

**Python implementation**

The python implementation can be found [here](https://github.com/Archfx/FPGA_depthMap/blob/master/Python_test_implementation/Disparity_Python_implementation_scratch.ipynb)

Test images used
For the functional verification, I have used the most famous stereo image pair "Tsukuba" stereo pair



 <img width="320" align="left" src="https://github.com/Archfx/FPGA_depthMap/blob/master/Img/Tsukuba_L.png" text="Left image"><img width="320" align="right" src="https://github.com/Archfx/FPGA_depthMap/blob/master/Img/Tsukuba_R.png" text="Right image">
 <p align="center">
 <em>Left image and Right Tsukuba images </em>
 </p>

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

<p align="center">
  <img src="https://github.com/Archfx/FPGA_depthMap/blob/master/Python_test_implementation/Disparity__colorMap_Tsukuba_5_python.jpg">
  <p align="center">
<em>Python results</em>
</p>
</p>

For this generation, it took more than 4 seconds using an average laptop computer without any accelerating techniques.
Based on the Python implementation Abstract flow chart is generated as follows.

<p align="center">
  <img  src="https://github.com/Archfx/FPGA_depthMap/blob/master/Img/FlowChart.png">
  <p align="center">
  <em>Disparity generation Flow chart</em>
  </p>
</p>

Then this algorithm is directly ported to Verilog. The implementation was done using ISE design suite by Xilinx. The image files were converted to hex and imported to the simulation and the output is directly saved as a Bitmap image.


<p align="center">
  <img  src="https://github.com/Archfx/FPGA_depthMap/blob/master/Img/VerilogSimulationTime.png">
  <p align="center">
  <em>Timing diagrams at 50MHz</em>
  </p>
</p>

<p align="center">
  <img  src="https://github.com/Archfx/FPGA_depthMap/blob/master/output.png">
  <p align="center">
   <em>Simulation Output</em>
   </p>
</p>

*** these modules are only for simulation purposes, Do not synthesize the code.


## Stereo Camera implementation

The cameras that were used for this project is very inexpensive OV7670 modules. They are commonly available and the output can be configured to 8bit parallel.
These cameras are using I2C interface to communicate with the master. We can configure the camera output by changing the internal registers of the cameras. 

Camera PINOUTS
Connection with BASYS 3

This repo contains VHDL implementation for image read from two cameras and displaying the average of two images from the VGA output.

OV7670 dual camera mount was designed using a cad tool and 3D printed to mount the cameras. STL files for camera mount can be found from here.


## Real-time depth map generation on FPGA

When converting the functional verification module into synthesizable code due to limited functionalities in Verilog, VHDL was selected as the developing language.

The system outputs the generated disparity map using the VGA output of the FPGA.
Following are recorded output from the monitor using a camera.

<p align="center">
  <img width="460" height="300" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/Bottle.gif">
     <p align="center">
     <em>Demo -1</em>
     </p>
</p>

<p align="center">
  <img width="460" height="300" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/hand.gif">
  <p align="center">
  <em>Demo -2</em>
  </p>
</p>

In both the demonstrations you may observe that camera exposure changes with the environement changes. Improvements are needed to fix this. It will reduce the noise in the output.
