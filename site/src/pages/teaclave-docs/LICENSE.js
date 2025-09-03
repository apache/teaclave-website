import { useEffect } from 'react';

export default function TeaclaveDocsLicense() {
  useEffect(() => {
    window.location.href = 'https://github.com/apache/teaclave/blob/main/LICENSE';
  }, []);

  return null; // Return null to show nothing
} 