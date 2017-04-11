# PostProcessingCellShading
A look at what cell shading could look like if done as a post-processing effect rather than a shader.

## TO DO:
- Clean up resolution scaling
- Port ruby K-means code to python
- Optimize python code where possible
- Consider using less external libs to further optimize?
- Attempt more image denoising on finished product (maybe)
- Port python code to be independent of ipython
- Make process compatible with non-PNG images

## Instructions:
1. Convert image to PNG if it is not already in that format
2. Run final.rb (ruby final.rb from command line)
3. Input relative directory of file to be processed (this will run k-means segmentation)
4. Open ipython notebook "Final Touches.ipynb"
5. Run module
6. The processed image will appear below the module
