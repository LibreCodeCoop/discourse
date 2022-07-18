import http from 'node:https'

const defer = () => {
  const self = {};

  self.promise = new Promise((resolve, reject) => {
    self.resolve = resolve;
    self.reject = reject;
  });

  return self;
};

const loadDroplets = (token, tagName) => {
  const deferred = defer()

  http.get({
    hostname: 'api.digitalocean.com',
    path: `/v2/droplets?tag_name=${tagName}`,
    headers: {
      Authorization: `Bearer ${token}`
    },
    agent: false
  }, (res) => {
    const response = []

    res.on('data', (chunk) => {
      response.push(chunk)
    })

    res.on('end', () => {
      deferred.resolve(JSON.parse(response.join('')));
    });
  }).on("error", (err) => {
    deferred.reject(err)
  })

  return deferred.promise
}

const generateLines = (group, droplets) => {
  const lines = droplets
    .map(({ name, ip }) => {
      return `${name} ansible_host=${ip} ansible_ssh_user=root`
    })

  return [
    `[${group}]`,
    ...lines,
    ''
  ]
    .join('\n')
}

const generateAll = droplets => {
  return generateLines('all', droplets)
}

const run = (token, environment) => {
  return loadDroplets(token, `droplet-${environment}`)
    .then(response => {
      const droplets = response === null || response === void 0 ? void 0 : response.droplets;

      if (droplets) {
        return droplets
      }

      return Promise.reject(new Error(`Invalid response ${JSON.stringify(response)}`))
    })
    .then(droplets => {
      return droplets.map(({ name, networks, tags }) => {
        const network = networks.v4.find(({ type }) => type === 'public')
        return { name, ip: network.ip_address, tags }
      })
    })
    .then(droplets => {
      return droplets.sort((a, b) => {
        return a.name.localeCompare(b.name);
      })
    })
    .then(droplets => {
      const all = generateAll(droplets)

      return [all].join('\n\n')
    })
}

run(process.env.DIGITALOCEAN_ACCESS_TOKEN, process.env.NODE_ENV)
  .then(console.log)
  .catch(err => {
    console.error(err)
    process.exit(1)
  })