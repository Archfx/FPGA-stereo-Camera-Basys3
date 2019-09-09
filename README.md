---


---

<h1 id="depthmap-generation-on-fpga">DepthMap generation on FPGA</h1>
<pre class=" language-diff"><code class="prism  language-diff"><span class="token deleted">- This project is still in Progress</span>
</code></pre>
<p>Most of the image processing projects in academia has been done on higher-end FPGA’s with a considerable amount of resources. The main objective of this project is to implement a reliable embedded system on a lower end FPGA with limited resources. This project is based on Disparity calculation based on SAD (Sum of Absolute Difference) algorithm and creating a depth map.</p>
<img width="300" height="200" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/basys3.png" align="right">
<img width="200" height="200" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/ov7670.jpg" align="right">
<p>Hardware used for this project</p>
<ul>
<li>Basys 3 FPGA board</li>
<li>2x OV7670 image sensor modules<br>
<br><br>
<br><br>
<br><br>
<br></li>
</ul>
<p>This project has 3 major sections</p>
<ol>
<li><a href="https://github.com/Archfx/FPGA_depthMap">Functional verification of disparity generator based on Verilog</a></li>
<li><a href="https://github.com/Archfx/FPGA-stereo-Camera-Basys3">Stereo camera implementation using OV7670 sensors based on VHDL</a></li>
<li><a href="https://github.com/Archfx/FPGA-DepthMap-Basys3">Real time disparity generation on Basys3 FPGA</a></li>
</ol>
<h2 id="functional-verification">Functional verification</h2>
<p>Hardware description languages(HDL) are not meant to be for rapid prototyping. Therefore, in this case, I have used python as the prototyping tool. The SAD algorithm was implemented on python from scratch without using any external library. I refrained from using 2D image arrays to store data because then the HDL implementation is straight forward.</p>
<p><strong>SAD theory</strong></p>
<p>Sum of Absolute difference is based on a simple geometric concept. Where they use the stereo vision to calculate the distance to the objects. For the implementation, two cameras should be on the same plane and they should not have any vertical offsets in their alignments.</p>
<p><strong>Python implementation</strong></p>
<p>The python implementation can be found <a href="https://github.com/Archfx/FPGA_depthMap/blob/master/Python_test_implementation/Disparity_Python_implementation_scratch.ipynb">here</a></p>
<p>Test images used<br>
For the functional verification, I have used the most famous stereo image pair “Tsukuba” stereo pair</p>
<p><img width="320" align="left" src="https://github.com/Archfx/FPGA_depthMap/blob/master/Img/Tsukuba_L.png"><img width="320" align="right" src="https://github.com/Archfx/FPGA_depthMap/blob/master/Img/Tsukuba_R.png"></p>
 <p align="center">
 <em>Left image and Right Tsukuba images </em>
 </p>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<p align="center">
  <img src="https://github.com/Archfx/FPGA_depthMap/blob/master/Python_test_implementation/Disparity__colorMap_Tsukuba_5_python.jpg">
  </p><p align="center">
<em>Python results</em>
</p>

<p>For this generation, it took more than 4 seconds using an average laptop computer without any accelerating techniques.<br>
Based on the Python implementation Abstract flow chart is generated as follows.</p>
<p align="center">
  <img src="https://github.com/Archfx/FPGA_depthMap/blob/master/Img/FlowChart.png">
  </p><p align="center">
  <em>Disparity generation Flow chart</em>
  </p>

<p>Then this algorithm is directly ported to Verilog. The implementation was done using ISE design suite by Xilinx. The image files were converted to hex and imported to the simulation and the output is directly saved as a Bitmap image.</p>
<p align="center">
  <img src="https://github.com/Archfx/FPGA_depthMap/blob/master/Img/VerilogSimulationTime.png">
  </p><p align="center">
  <em>Timing diagrams at 50MHz</em>
  </p>

<p align="center">
  <img src="https://github.com/Archfx/FPGA_depthMap/blob/master/output.png">
  </p><p align="center">
   <em>Simulation Output</em>
   </p>

<p>*** these modules are only for simulation purposes, Do not synthesize the code.</p>
<h2 id="stereo-camera-implementation">Stereo Camera implementation</h2>
<p>The cameras that were used for this project is very inexpensive OV7670 modules. They are commonly available and the output can be configured to 8bit parallel.<br>
These cameras are using I2C interface to communicate with the master. We can configure the camera output by changing the internal registers of the cameras.</p>
<p align="center">
  <img src="https://github.com/Archfx/FPGA-stereo-Camera-Basys3/blob/master/PinOuts/Connector%20pins.jpg">
     </p><p align="center">
     <em>Pmod connections with Cameras</em>
     </p>

<p align="center">
  <img src="https://github.com/Archfx/FPGA-stereo-Camera-Basys3/blob/master/PinOuts/basys3.png">
     </p><p align="center">
     <em>Pmod connector pinouts</em>
     </p>

<p align="center">
  <img src="https://github.com/Archfx/FPGA-stereo-Camera-Basys3/blob/master/PinOuts/pMod.png">
     </p><p align="center">
     <em>Basys3 Pmod pinout diagram</em>
     </p>

This repo contains VHDL implementation for image read from two cameras and displaying the average of two images from the VGA output.
<p>OV7670 dual camera mount was designed using a cad tool and 3D printed to mount the cameras. STL files for camera mount can be found from <a href="https://github.com/Archfx/FPGA-stereo-Camera-Basys3/tree/master/CamMountCAD">here</a>.</p>
<p align="center">
  <img width="230" height="200" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/cad.png">
     </p><p align="center">
     <em>CAD Stereo camera mount</em>
     </p>

<p align="center">
  <img width="800" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/assembled.jpg">
     </p><p align="center">
     <em>Hardware connected together</em>
     </p>

<p><strong>Camera configuration</strong></p>
<p>OV7670 camera module comes with I2C interface to configure it’s internal registers. The problem here is we are using two cameras with the same type. By taking the advantage of paralel hardware implementation on FPGA two seperate I2C buses were used for the dual camera intergration. Fortunatly prioir work related to OV7670 Camera intergration to Zedboard FPGA has been done by the Engineer <a href="https://github.com/hamsternz">Mike Field</a> at <a href="http://hamsterworks.co.nz/mediawiki/index.php/OV7670_camera">here</a>.<br>
This was I2C driver was direcly ported to the Basys3 FPGA. Camera register configuration was done inorder to get required output from the Camera.</p>
<h2 id="real-time-depth-map-generation-on-fpga">Real-time depth map generation on FPGA</h2>
<p>When converting the functional verification module into synthesizable code due to limited functionalities in Verilog, VHDL was selected as the developing language.</p>
<p>The system outputs the generated disparity map using the VGA output of the FPGA.<br>
Following are recorded output from the monitor using a camera.</p>
<p align="center">
  <img width="460" height="300" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/Bottle.gif">
     </p><p align="center">
     <em>Demo -1</em>
     </p>

<p align="center">
  <img width="460" height="300" src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/hand.gif">
  </p><p align="center">
  <em>Demo -2</em>
  </p>

<p>In both the demonstrations you may observe that camera exposure changes with the environement changes. Improvements are needed to fix this. It will reduce the noise in the output.<br>
Auto Exposure Correction (AEC) has been disabled from the cameras by editing the internal register modules. After disableing AEC, the result was much more clear and the noise was removed from the background.</p>
<p><strong>Image Rectification and Camera Caliberation</strong></p>
<p>The offsets of the two cameras are fixed using a image rectification module. Although the Automatic Exposure Caliberation is turned of one of the Cameras output is very darker while the other one is too bright. This should be corrected for the Disparity aldorithm to work correctly.</p>
<p align="center">
  <img src="https://github.com/Archfx/FPGA-DepthMap-Basys3/blob/320x240/IMG/Demo_rectified_Colorbal_issue.gif">
  </p><p align="center">
  <em>Demo -3</em>
  </p>


