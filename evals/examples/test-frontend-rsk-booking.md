# Input: test-frontend in an RSK app

The repository is a React app. It has `kit.lock.json` at its root (`"target": "vite"`). You cannot open the repository: work from the skill and the files it points to, and write your answer as text (file paths and code). Do not run commands.

The app has no whole-app render helper yet. Request from the Tech Lead:

> Write a page test for the "New booking" page at /bookings/new: choose the site "Site B" in the searchable Site field,
> set the booking date to 14 March 2026 and the arrival time to 10:30 AM, fill the contact name "Dana Example", save,
> and check the POST body and that the success toast "Booking saved" shows. Also check that no error toast shows. Last
> time a page test passed locally and failed on the pipeline with "Unable to find role" after one second.
