// Routes
import NotFound from '../components/NotFound'

import Home from '../views/Home'


export const routes = [
  {
    path: "/",
    element: <Home />,
    errorElement: <NotFound />,
    children: [
    ]
  },
  
]