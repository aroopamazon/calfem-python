'''Example 04.

Structured 3D meshing. Adding texts and labels to figures. Altering axis properties.
''' 

import calfem.geometry as cfg
import calfem.mesh as cfm
import calfem.vis as cfv
import visvis as vv

# ---- Define geometry ------------------------------------------------------

g = cfg.Geometry()

# Add Points

g.addPoint([0, 0, 0], ID=0)
g.addPoint([0.5, -0.3, -0.3], 1)
g.addPoint([1, 0, 0], 2)
g.addPoint([1, 1, 0], 3)
g.addPoint([0, 1, 0], 4, marker = 11) # Set some markers no reason.
g.addPoint([0, 0, 1], 5, marker = 11) # (markers can be given to points as well
                                      # as curves and surfaces)
g.addPoint([1, 0, 1], 6, marker = 11)
g.addPoint([1, 1, 1], 7)
g.addPoint([0, 1, 1], 8)

# Add splines

g.addSpline([0, 1, 2], 0, marker = 33, elOnCurve = 5)
g.addSpline([2, 3], 1, marker = 23, elOnCurve = 5)
g.addSpline([3, 4], 2, marker = 23, elOnCurve = 5)
g.addSpline([4, 0], 3, elOnCurve = 5)
g.addSpline([0, 5], 4, elOnCurve = 5)
g.addSpline([2, 6], 5, elOnCurve = 5)
g.addSpline([3, 7], 6, elOnCurve = 5)
g.addSpline([4, 8], 7, elOnCurve = 5)
g.addSpline([5, 6], 8, elOnCurve = 5)
g.addSpline([6, 7], 9, elOnCurve = 5)
g.addSpline([7, 8], 10, elOnCurve = 5)
g.addSpline([8, 5], 11, elOnCurve = 5)

# Add surfaces

g.addStructuredSurface([0, 1, 2, 3], 0, marker=45)
g.addStructuredSurface([8, 9, 10, 11], 1)
g.addStructuredSurface([0, 4, 8, 5], 2, marker=55)
g.addStructuredSurface([1, 5, 9, 6], 3, marker=55)
g.addStructuredSurface([2, 6, 10, 7], 4)
g.addStructuredSurface([3, 4, 11, 7], 5)

# Add Volume:
#  addStructuredVolume() takes three args. The first is a list of surface IDs 
#  (structured surfaces). The surfaces should make a hexahedron 
#  (i.e. 6 surfaces). Other kinds of structured volumes than hexahedra will
#  not work for hexahedral elements, which is the only type of 3D element that 
#  CALFEM handles. The two optional parameters are the volume ID and 
#  volume marker.

g.addStructuredVolume([0,1,2,3,4,5], 0, marker=90)

# ---- Create mesh ----------------------------------------------------------

# Element type 5 is hexahedron. (See user manual for more element types)

elType = 5 

# Degrees of freedom per node.

dofsPerNode= 1 

# Create mesh

coords, edof, dofs, bdofs, _ = cfm.createGmshMesh(geometry = g, elType = elType,
                                              dofsPerNode = dofsPerNode)

# ---- Visualise mesh -------------------------------------------------------

# Hold Left Mouse button to rotate.
# Hold right mouse button to zoom.
# Hold SHIFT and left mouse button to pan.
# Hold SHIFT and right mouse button to change the field of view.
# Hold Ctrl and left mouse button to roll the camera. 

# Draw geometry

cfv.drawGeometry(g, drawPoints=False)

# Draw mesh

vv.figure()
cfv.drawMesh(coords=coords, edof=edof, dofsPerNode=dofsPerNode, elType=elType, filled=True)

# Add a text in world space

cfv.addText("This is a Text", pos=(1, 0.5, 0.5), angle=45)  

# Add a label in the screen space

ourLabel = cfv.addLabel("This is a Label", pos=(20,30), angle=-45) 

# We can change the attributes of labels and texts, such as color and position.

ourLabel.text = "Label, changed." 

# Make it red. (1,0,0) would also have worked.

ourLabel.textColor = 'r'  

# Matlab style axes (three axes in the background instead of a cube)

vv.gca().axis.showBox = 0 

#Change the limits of the axes.

vv.gca().SetLimits(rangeX=(0,2), rangeY=(-1,1.5), rangeZ=(-0.5,2), margin=0.02) 

# Enter main loop

app = vv.use()
app.Create()
app.Run()