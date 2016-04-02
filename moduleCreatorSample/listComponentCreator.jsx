import React from 'react';

export default function listComponentCreator (arr, className) {
  return <div className={className} >{arr}</div>
}