# QuizApp
a quiz app demo with 5 questions

- Download a list of onboarding questions using the provided mock networking client. This service returns the list of questions as either NSData, InputStream, or String after adding an artificial latency of 1-5 seconds.
* fixed main thread blocked issue with GCD, added delegation to update VC when the fetch is finished
* Also disabled Buttons' actions when loading the data,

- Parse the list of questions and display each question within a separate single view.
* Achieved during the interview

- At the bottom of each view there will be a button that says “next.” Tapping on this button will save the answer and present the next question to the member.
* Achieved during the interview

- At the end, the app will display the member’s profile with the answers provided.
* Improved profile vc with a better look

- App should be able to be rotated w/o losing any data
* Achieved by setting up constrains

- Allow the member to edit their answers (start over, asking each question again but show the previously entered values)
* Achieved by loading prev answers from QAManager to textfield

- On each card add a button to go back to the previous question
* Achieved by adding a back Button

- Caching responses on disk
* Achieved with NSCache when first loading data

- Validate the input based on the data type from the API. Ex. If the API response says an answer is an integer, make sure the answer only contains numeric values.
* Achieved by setting up keyboard type based on the question type
