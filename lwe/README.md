# scanner-lab-simulate-website 

scanner-lab-simulate-website is a image to create single html with given MB size.

The main purpose of this image is to be used within scanner-lab to test memory caching behaviour and may produce out of memory issues.

When no size is given it will randomly choose a size between 1 and 256.

## Environment Parameter

| Name | Default | Description |
| --- | --- | --- |
| HTML_MB_SIZE | Between 1 and 256 | The size of the generated html site on root |
| PORT | :80 | The port to listen to |
