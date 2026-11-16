# Input: create-api in an RSK app

The repository is a React app. It has `kit.lock.json` at its root (`"target": "vite"`). You cannot open the repository: work from the skill and the files it points to, and write your answer as text (file paths and code). Do not run commands.

Request from the Tech Lead:

> Integrate the orders API. The API document says: `GET /api/v1/orders` (list, query `page`, `pageSize`) and
> `POST /api/v1/orders` (body `{ customerName, amount }`, answers 201 with the order). Errors answer
> `{ status, code, detail }`, for example 409 `{ code: "order_duplicate" }`. The app's `appConfig.ts` has
> `VITE_APP_API_URL: 'https://demo-api.example.test/api/v1'`. After creating an order, people should see that it worked.
