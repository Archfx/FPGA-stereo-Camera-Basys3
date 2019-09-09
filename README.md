
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

**SAD/SSD  theory** 

Sum of Absolute difference and Sum of Squared Difference Disparity calculation theory is based on a simple geometric concept. Where they use the stereo vision to calculate the distance to the objects. For the implementation, two cameras should be on the same plane and they should not have any vertical offsets in their alignments.



<a  href="https://www.codecogs.com/eqnedit.php?latex=D(x,y,d)&space;=&space;|I_l(x,y)-I_r(x-d,y)|^2" target="_blank"><img align="center" src="https://latex.codecogs.com/gif.latex?D(x,y,d)&space;=&space;|I_l(x,y)-I_r(x-d,y)|^2" title="Sum of Squred difference" /></a>

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
<p align="center">
  <img src="https://github.com/Archfx/FPGA-stereo-Camera-Basys3/blob/master/PinOuts/Connector%20pins.jpg">
     <p align="center">
     <em>Pmod connections with Cameras</em>
     </p>
</p>
<p align="center">
  <img src="https://github.com/Archfx/FPGA-stereo-Camera-Basys3/blob/master/PinOuts/basys3.png">
     <p align="center">
     <em>Pmod connector pinouts</em>
     </p>
</p>
<p align="center">
  <img src="https://github.com/Archfx/FPGA-stereo-Camera-Basys3/blob/master/PinOuts/pMod.png">
     <p align="center">
     <em>Basys3 Pmod pinout diagram</em>
     </p>
</p>
This repo contains VHDL implementation for image read from two cameras and displaying the average of two images from the VGA output.

OV7670 dual camera mount was designed using a cad tool and 3D printed to mount the cameras. STL files for camera mount can be found from [here](https://github.com/Archfx/FPGA-stereo-Camera-Basys3/tree/master/CamMountCAD).
<p align="center">
  <img width="230" height="200" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/cad.png">
     <p align="center">
     <em>CAD Stereo camera mount</em>
     </p>
</p>
<p align="center">
  <img width="800" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/assembled.jpg">
     <p align="center">
     <em>Hardware connected together</em>
     </p>
</p>

**Camera configuration**

OV7670 camera module comes with I2C interface to configure it's internal registers. The problem here is we are using two cameras with the same type. By taking the advantage of paralel hardware implementation on FPGA two seperate I2C buses were used for the dual camera intergration. Fortunatly prioir work related to OV7670 Camera intergration to Zedboard FPGA has been done by the Engineer [Mike Field](https://github.com/hamsternz) at [here](http://hamsterworks.co.nz/mediawiki/index.php/OV7670_camera). 
This was I2C driver was direcly ported to the Basys3 FPGA. Camera register configuration was done inorder to get required output from the Camera.

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
Auto Exposure Correction (AEC) has been disabled from the cameras by editing the internal register modules. After disableing AEC, the result was much more clear and the noise was removed from the background.

**Image Rectification and Camera Caliberation**

 The offsets of the two cameras are fixed using a image rectification module. Although the Automatic Exposure Caliberation is turned of one of the Cameras output is very darker while the other one is too bright. This should be corrected for the Disparity aldorithm to work correctly.

<p align="center">
  <img src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/Demo_rectified_Colorbal_issue.gif">
  <p align="center">
  <em>Demo -3  ( Left : Disparity output | Right : average image of two cameras )</em>
  </p>
</p>
If we observe closely left camera brightness is too lower than the right hand side camera.

<br/></br>

**Resource Utilization**

Basys 3 is a entry level FPGA board. Hence it is not designed for image processing tasks. The Challange here was to run complex image processing algorithm on limited resources. Basys 3 Trainer FPGA board consists of following resources.


<table align="center" class="tg">
  <tr>
    <th class="tg-0pky">Resource</th>
    <th class="tg-c3ow">Available</th>
  </tr>
  <tr>
    <td class="tg-0pky">LUT<br></td>
    <td class="tg-c3ow">20800</td>
  </tr>
  <tr>
    <td class="tg-0pky">LUTRAM</td>
    <td class="tg-c3ow">9600</td>
  </tr>
  <tr>
    <td class="tg-0pky">FF</td>
    <td class="tg-c3ow">41600</td>
  </tr>
  <tr>
    <td class="tg-0lax">BRAM</td>
    <td class="tg-0lax">50</td>
  </tr>
  <tr>
    <td class="tg-0lax">DSP</td>
    <td class="tg-0lax">90</td>
  </tr>
  <tr>
    <td class="tg-0lax">IO</td>
    <td class="tg-0lax">106</td>
  </tr>
  <tr>
    <td class="tg-0lax">BUFG</td>
    <td class="tg-0lax">32</td>
  </tr>
  <tr>
    <td class="tg-0lax">MMCM</td>
    <td class="tg-0lax">5</td>
  </tr>
</table>

The main bottle necks were the Block memory and the LUTRAM.  Basys 3 has 1,800Kbits of memory in 50 cells as 36,000bits in each cell. We are getting the camera output in YCbCr format. Here Y is the gray scale image of individual pixel size 4bits.

    Memory requirement calculation
    For left image : 320x240x4 bits
    For right image : 320x240x4 bits
    For Average image : 320x240x4 bits
    For Disparity image : 320x240x8 bits
    Total memory required : 1,536,000 bits/1,800 000 bits

We cant process them images while it is in the BRAM because BRAM is FIFO (First In First Out) memory device. Therefor the Image sholud be loaded in a cache so that data can be accessed parallely. The cache can be created using the LUTRAM. The problem we have is the LUTRAM is insufficient to store two 320x240 images. Even the 160x120 size images cannot be stored to support SAD algorithm to compare.

<p align="center">
  <img src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/LUT_problem.png">
  <p align="center">
  <em>LUT bottleneck for 160x120 resolution</em>
  </p>
</p>

Therefore a blockwise disparity calculation was used in order to utilize the full 320x240 resolution with available resources. The caching is done in block wise and then the caculated dispairty values are saved to the disparity_buffer circuit.

```diff
- Although there are 9600 LUTRAMS are available we cannot ulilize 100% of that due to routing issues. 

```
<p align="center">
  <img src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/routing_problm.png">
  <p align="center">
  <em>Routing failure</em>
  </p>
</p>
<p align="center">
<img src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/utilization.png">
  <p align="center">
  <em>Blockwise disparity calculation Utilization at 320x240 resolution</em>
  </p>
</p>
