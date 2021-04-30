import createConnectionPool, {sql} from '@databases/pg';

async function run() {
  const db = createConnectionPool(
    'postgres://macuser@localhost:5432/glossarydb',
  );

  const results = await db.query(sql`
    SELECT 1 + 1 as result;
  `);

  console.log(results);
  // => [{result: 2}]

  await db.dispose();
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});

