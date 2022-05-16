# MemeMe2.0
MemeMe is a meme-generating app that enables users to attach a caption to a picture. Users pick the picture from the device's camera or photo album. After creating the meme, users can share it with friends.

## Screens Overview
The app has three pages of content:
* **Meme Editor View:** This allows users to create a meme and share it
* **Sent Memes View:** This allows users to browse the list of sent memes
* **Meme Detail View:** Displays a meme fullscreen
## Screens Details
### Meme Editor View
It consists of the following components:
* an Image View with two text fields on top of it. They prompt the user to create his meme.
* a toolbar with two buttons:
  * one for accessing the device's camera
  * one for viewing the sent memes list
* a _Share_ button on the top-left corner of the screen
* a _Cancel_ button on the top-right corner of the screen
### Sent Memes View
It consists of the following components:
* a grid or table showing recently sent memes. Each meme image gets presented fullscreen when tapped
* an Add button to navigate to the MemeEditorView
## Roadmap
- [ ] Add memes persistence
- [ ] Try to use the Adapter pattern to reduce the table and collection view controllers to just one controller
- [ ] Make use of the MemeView in MemeEditorVC 
## Requirements
To build and run the app, you need the following:
* iOS 13.0
* Xcode 11
## License
MIT License

Copyright (c) 2022 Fabio Tiberio

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
