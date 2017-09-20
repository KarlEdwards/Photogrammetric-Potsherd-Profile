# Photogrammetric-Potsherd-Profile
A procedure for using photography to estimate key artifact dimensions 
## Overview
* Set the stage
* Place the artifact on a turntable and take photographs at 10-degree intervals
* Convert the image files to a textured mesh
* Convert the textured mesh to a stereolithography model
* Manipulate and measure the model

## Details
### Set the Stage
* Select a location with plenty of natural light
* Put dark paper or cloth under and behind the turntable to serve as a backdrop
* Attach the camera to a tripod and adjust the height so the center of the lense is at the same height as the center of the artifact to be photographed
![image](https://github.com/KarlEdwards/Photogrammetric-Potsherd-Profile/blob/master/illustration_stage.JPG)
### Place the artifact on a turntable and take photographs at 10-degree intervals
![image](https://github.com/KarlEdwards/Photogrammetric-Potsherd-Profile/blob/master/illustration_every_ten_degrees.png)
### Convert the image files to a textured mesh
* If you are not already an ARC3D user, apply for a free account [here](https://homes.esat.kuleuven.be/~visit3d/webservice/v2/request_login.php)
* Upload images to ARC3D web service; pour yourself a cup of coffee
* In a few minutes to a few hours, if all goes well, ARC3D will send you a textured mesh object
### Convert the textured mesh to a stereolithography model
* One way to do this is to use a utility called [meshconv](http://www.patrickmin.com/meshconv/), as follows:
  * Input file: textured_mesh.obj
  * Convert to .stl format: -c stl
  * Output file: -o stereolithograph[.stl]
  * Putting it all together:
    * ./meshconv textured_mesh.obj -c stl -o stereolithograph
### Manipulate and measure the model
* The R package, [rgl](https://www.rdocumentation.org/packages/rgl/versions/0.97.0) provides some handy tools for this purpose
