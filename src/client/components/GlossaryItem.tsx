import { useState } from 'react';

export default (props: any) => {
  const { item } = props;
  const [definition, setDefinition] = useState(item.definition);

  const saveDefinition = async () => {
    console.log("Loading entries");
    const res = await fetch(
      "/entry",
      {
        method: "PUT",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ definition })
      }
    );
    console.log(res);
  };
  return (
    <div>
      <h4>{item.name}</h4>
      <textarea className="definition" onChange={(e) => setDefinition(e.target.value)}value={definition}></textarea>
      <button onClick={saveDefinition}>Save</button>
    </div>
  )
}
