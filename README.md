# MemeMe2.0
MemeMe is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share it with friends. MemeMe also temporarily stores sent memes which users can browse in a table or a grid.

## Structure
The app has three pages of content:
* **Meme Editor View:** Enables a user to add text to an image and share it. 
* **Sent Memes View:** Enables a user to browse sent memes in a table or a grid.
* **Meme Detail View:** Displays an image of a sent meme
### Meme Editor View
The Meme Editor View consists of the following components:
* An **Image View** overlaid by two text fields, one near the top and one near the bottom of the image. 
* A **Bottom Toolbar** with two buttons: one for the camera and one for the photo album. 
* The **Top Navigation Bar** with a share button on the left displaying Apple’s stock share icon and a "_Cancel_" button on the right.
### Sent Memes View
The Sent Memes View displays recently sent memes allowing the user to see them in a table or in a grid. Selecting a meme from the table or collection presents the Meme Detail View. Pressing the “add” button in the right corner of the Top Navigation Bar brings up the Meme Editor View.
### Meme Detail View
The Meme Detail View displays the selected meme in an image view in the center of the page with the meme’s original aspect ratio. The detail view has a back arrow in the top left corner. To the right of the arrow reads the title of the previous view, “Sent Memes.”
