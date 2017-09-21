# Photogrammetric Potsherd Profile
A procedure for using photography to estimate key artifact dimensions

## Tools and Materials
* An artifact to measure
* Photography
  * Location with plenty of natural light. See [photography guidelines](https://homes.esat.kuleuven.be/~visit3d/webservice/v2/manual3.php#SEC2)
  * Work table
  * Camera
  * Tripod
  * Turntable
  * Dark background
* ARC3D Account
  * If you are not already an ARC3D user, apply for a free account [here](https://homes.esat.kuleuven.be/~visit3d/webservice/v2/request_login.php)
* Utility: [meshconv](http://www.patrickmin.com/meshconv/)
* R, with these packages
  * rgl
  * ggplot2
  * purrr
  * tibble
  * lattice

## Procedure
### Set the Stage
* Put dark paper or cloth under and behind the turntable to serve as a backdrop
* Adjust the height of the camera on the tripod so the center of the lense is at the same height as the center of the artifact to be photographed
<img src="https://github.com/KarlEdwards/Photogrammetric-Potsherd-Profile/blob/master/illustration_stage.JPG" width="500">

### Place the artifact on the turntable and take photographs at roughly 10-degree intervals
<img src="https://github.com/KarlEdwards/Photogrammetric-Potsherd-Profile/blob/master/illustration_every_ten_degrees.png" width="500">

### Convert the image files to a textured mesh
* Upload images to ARC3D web service
* Pour yourself a cup of coffee
* In a few minutes to a few hours, if all goes well, ARC3D will send you a textured mesh object
<img src="https://github.com/KarlEdwards/Photogrammetric-Potsherd-Profile/blob/master/model.png" width="150">

### Convert the textured mesh to a stereolithography model
* The conversion utility
  * meshconv
* The input file (obtained from ARC3D)
  * textured_mesh.obj 
* Desired output format
  * -c stl
* Output file
  * -o stereolithograph[.stl]
#### Putting it all together into a command:
./meshconv textured_mesh.obj -c stl -o stereolithograph

### Manipulate and measure the model
* The R package, [rgl](https://www.rdocumentation.org/packages/rgl/versions/0.97.0) provides some handy tools for this purpose
