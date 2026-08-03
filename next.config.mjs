import { imageHosts } from './image-hosts.config.mjs';

/** @type {import('next').NextConfig} */
const nextConfig = {
  serverExternalPackages: ['mssql', 'tedious'],

  productionBrowserSourceMaps: false,

  images: {
    remotePatterns: imageHosts,
    minimumCacheTTL: 60,
    qualities: [75, 85, 100],
  },
};

export default nextConfig;