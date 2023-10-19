## AOPN Generation based on data from AOPWiki v2.6

This project is licensed under the terms of the Creative Commons Attribution 4.0 International license.


The AOPWiki is accessible at https://aopwiki.org/ and data download can be found at https://aopwiki.org/info_pages/5.

This R-script requires only an Excel file with list of relevant AOPs (a table with a single column) and the data from the AOPWiki. The TSV files from the wiki should be placed in a subfolder "Data" in the working directory. The output is a semicolon (;) separated file.
See the example data and list of AOPs to be exported in the example data folder.

#### Import into Cytoscape

Cytoscape (https://cytoscape.org/) is a freely available software, and is used to automatically generate a network based on the output file from the R-script.

##### Important to note when importing the file to Cytoscape:
To import the file, choose File->Import->Network from File... and select the R-script output file.

Open the Advanced Options, **deselect** the ", (comma)" delimiter, and **select** only the "; (semicolon)" delimiter. Press OK. (**NOTE: The current script saves the file as a tab-separated file which is automatically detected by Cytoscape. This step is not required unless you manually change the delimiter in R.**)

The columns that have to be edited to create a functioning network are the "Event" and "Target" columns.
The Event column should have the meaning "Source node" and the Target column should have the "Target Node" meaning. This will create a functioning network, however the visualization options for the related parameters will be limited. 
The following options were used to create the network in the related publication:

- Event - Source Node
- AOP - Edge Attribute
- Event_Type - Source Node Attribute
- Description - Source Node Attribute
- Target - Target Node
- Relationship - Edge Attribute
- Adjacency - Interaction Type
- Evidence - Edge Attribute
- Quantitative - Edge Attribute
- Direction - Edge Attribute
- Object_Source - Source Node Attribute
- Object_Ontology_ID - Source Node Attribute
- Object_Term - Source Node Attribute
- Process_Source - Source Node Attribute
- Process_Ontology_ID - Source Node Attribute
- Process_Term - Source Node Attribute

These options may of course be changed depending on the purpose of the generated network.
