import GlossaryItem from './GlossaryItem';
import { useState, useEffect } from 'react';
import '../scss/style.scss';

export default (props: any) => {
  const [entries, setEntries] = useState([]);
  const fetchEntries = async () => {
    console.log("Loading entries");
    const res = await fetch("/entries");
    res
      .json()
      .then(res => setEntries(res))
      .catch(err => console.error(err));
  };

  useEffect(() => {
    fetchEntries();
  }, entries);

  return (
    <div>
      <h1>Glossary</h1>
      {entries.map((item: any) => <GlossaryItem item={item} />)}
    </div>
  )
}
