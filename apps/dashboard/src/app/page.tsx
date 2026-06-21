import { redirect } from 'next/navigation';

export default function Home() {
  console.log("Redirecting to /protected")
  redirect('/protected')
}
